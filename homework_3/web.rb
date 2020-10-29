require 'sinatra'
require './db_connector'

get '/foods' do
    items = get_all_items()
    erb :index, locals: {
        items: items
    }
end

get '/food_detail/:id' do
    id = params['id']
    item_details = get_item_details(id)
    erb :food_detail, locals: {
        item_details: item_details
    }
end

get '/foods/create' do
    categories = get_all_categories()
    erb :create_food, locals: {
        categories: categories
    }
end

post '/foods/create' do
    name = params['foodname']
    price = params['foodprice']
    category_id = params['foodcategory']
    create_new_item(name, price, category_id)
    redirect '/foods'
end

get '/foods/:id/edit' do
    id = params['id']
    item_details = get_item_details(id)
    categories = get_all_categories()
    erb :edit_food, locals: {
        item_details: item_details,
        categories: categories
    }
end

post '/foods/update' do
    name = params['foodname']
    price = params['foodprice']
    category_id = params['foodcategory']
    food_id = params['foodid']
    update_item(name, price, category_id, food_id)
    redirect '/foods'
end

get '/foods/:id/delete' do
    food_id = params['id']
    items = get_item_details(food_id)
    erb :delete_food, locals: {
        items: items
    }
end

post '/foods/:id/drop' do
    food_id = params['id']
    drop_item(food_id)
    redirect '/foods'
end