require 'grape'
require 'grape-route-helpers'
require 'grape-swagger'
require_relative '../config/loader'

class Api < Grape::API
  helpers AuthHelper

  format :json
  content_type :json, 'application/json'

  require 'rack/cors'
  use Rack::Cors do
    allow do
      origins '*'
      resource '*', headers: :any, methods: :get
    end
  end

  rescue_from Grape::Exceptions::ValidationErrors do
    error!({ errors: [{ details: I18n.t(:missing_params, scope: 'api.errors') }] }, 422)
  end

  rescue_from AuthHelper::UnauthorizedError do
    error!({ errors: [{ details: I18n.t(:unautorized, scope: 'api.errors') }] }, 403)
  end

  resource :ads do
    desc 'Список рекламных объявлений' do
      summary 'Эндпоинт получения списка рекламных объявлений'
      produces ['application/json']
      consumes ['application/json']
    end
    params do
      optional :page, type: Integer, desc: 'Номер страницы'
    end
    get do
      result = Ads::FetchRecords.call(params: env['rack.request.query_hash'], path: env['PATH_INFO'], page: params[:page])

      AdSerializer.new(result.ads, links: result.links).serializable_hash
    end

    desc 'Создание рекламного объявления' do
      summary 'Эндпоинт для создания рекламного объявления'
      produces ['application/json']
      consumes ['application/json']
    end
    params do
      group :ad, type: Hash do
        requires :title, type: String
        requires :description, type: String
        requires :city, type: String
      end
    end
    post do
      result = Ads::Create.call(user_id: user_id, **declared(params)[:ad].symbolize_keys)

      if result.success?
        AdSerializer.new(result.ad).serializable_hash
      else
        error! ErrorSerializer.from_model(result.ad), 422
      end
    end
  end

  add_swagger_documentation \
    mount_path: '/swagger/docs',
    info: {
      title: 'Ads API',
      description: 'An API for create and read the ads',
      contact_name: 'Andrew Ageev',
      contact_email: 'ageev86@gmail.com',
      license: 'MIT',
      license_url: "https://opensource.org/licenses/MIT",
    }
end