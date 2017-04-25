# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


#Criando os usuarios iniciais
User.create name: 'Jailton',email:'jailton@jksolucoes.com.br', password: 123456,status: :active, kind: :super
User.create name: 'davi',email:'davi@jornalodia.com.br', password: 123456,status: :active, kind: :manager
User.create name: 'Karina', email:'karina@jksolucoes.com.br',password: 123456,status: :active, kind: :pagination
User.create name: 'carivaldo', email:'carivaldo@jornalodia.com.br',password: 123456,status: :active, kind: :journalist
