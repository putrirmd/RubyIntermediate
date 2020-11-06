require 'sinatra'
require './controllers/items_controller.rb'
require './controllers/categories_controller.rb'

get '/' do
    controller = ItemsController.new
    controller.show_main_page()
end

# ---------------ITEMS RELATED---------------
get '/foods' do
    controller = ItemsController.new
    controller.show_all_items()
end

get '/foods/detail/:id' do
    controller = ItemsController.new
    controller.show_item_details(params)
end

get '/foods/create' do
    controller = ItemsController.new
    controller.create_item_form()
end

post '/foods/create' do
    controller = ItemsController.new
    controller.insert_new_item(params)
    redirect '/foods'
end

get '/foods/edit/:id' do
    controller = ItemsController.new
    controller.edit_item_form(params)
end

post '/foods/edit' do
    controller = ItemsController.new
    controller.save_edited_item(params)
    redirect '/foods'
end

get '/foods/delete/:id' do
    controller = ItemsController.new
    controller.delete_confirmation(params)
end

post '/foods/delete/:id' do
    controller = ItemsController.new
    controller.delete_choosen_item(params)
    redirect '/foods'
end

# ---------------CATEGORIES RELATED---------------
get '/categories' do
    controller = CetegoriesController.new
    controller.show_all_categories()
end

get '/categories/detail/:id' do
    controller = CetegoriesController.new
    controller.show_category_details(params)
end

get '/categories/create' do
    controller = CetegoriesController.new
    controller.create_category_form()
end

post '/categories/create' do
    controller = CetegoriesController.new
    controller.insert_new_category(params)
    redirect '/categories'
end

get '/categories/edit/:id' do
    controller = CetegoriesController.new
    controller.edit_categories_form(params)
end

post '/categories/edit' do
    controller = CetegoriesController.new
    controller.save_edited_category(params)
    redirect '/categories'
end

get '/categories/delete/:id' do
    controller = CetegoriesController.new
    controller.delete_confirmation(params)
end

post '/categories/delete/:id' do
    controller = CetegoriesController.new
    controller.delete_choosen_categories(params)
    redirect '/categories'
end