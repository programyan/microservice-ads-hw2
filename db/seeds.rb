(1..10).each do |index|
  Ad.create(
    user_id: rand(3),
    title: "Title #{index}",
    description: "Lorem ipusm dolor sit amet #{index}",
    city: ['Хабаровск', 'Санкт-Петербург'].sample
  )
end
