class Ad < Sequel::Model
  plugin :validation_helpers
  self.raise_on_save_failure = false

  def validate
    super

    validates_presence :title, message: I18n.t(:blank, scope: 'ad.errors.title')
    validates_presence :description, message: I18n.t(:blank, scope: 'ad.errors.description')
    validates_presence :city, message: I18n.t(:blank, scope: 'ad.errors.city')
    validates_presence :user_id, message: I18n.t(:blank, scope: 'ad.errors.user_id')
  end
end