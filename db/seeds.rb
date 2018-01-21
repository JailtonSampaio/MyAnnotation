# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


#Criando os usuarios iniciais
User.create name: 'Editor',email:'editor@jornalodia.com.br', password: 123456,status: :active, kind: :editor
User.create name: 'Matheus',email:'matheus@jornalodia.com.br', password: 123456,status: :active, kind: :portal
User.create name: 'Carivaldo', email:'carivaldo@jornalodia.com.br',password: 123456,status: :active, kind: :journalist

#Cria annotations para os usuarios
r = rand(5..50)
#seleciona os usuarios all e embaralha shuffle
User.all.shuffle.each do |usuario|
  (1..r).each do
    Annotation.create user_id: usuario.id, status: :active, title: Faker::Lorem.sentence(rand(5..10)), content: Faker::Lorem.paragraph(rand(2..8)), date: rand(30).days.ago
  end
  r = rand(2..50)

end



#Cria os administradores
User.create name: 'Jailton',email:'jailton@jksolucoes.com.br', password: 123456,status: :active, kind: :super
User.create name: 'Davi',email:'davi@jornalodia.com.br', password: 123456,status: :active, kind: :manager
User.create name: 'Karina', email:'karina@jksolucoes.com.br',password: 123456,status: :active, kind: :pagination
