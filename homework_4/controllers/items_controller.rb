require 'sinatra'
require './models/item.rb'
require './models/category.rb'

class ItemsController
    def show_main_page
        renderer = ERB.new(File.read("./views/index.erb"))
        renderer.result(binding)
    end

    def show_all_items
        items = Item.get_all_items()
        renderer = ERB.new(File.read("./views/food_list.erb"))
        renderer.result(binding)
    end

    def show_item_details(params)
        id = params['id']
        item_details = Item.get_item_by_id_for_food_details(id)
        renderer = ERB.new(File.read("./views/food_detail.erb"))
        renderer.result(binding)
    end

    def create_item_form
        categories = Category.get_all_categories()
        renderer = ERB.new(File.read("./views/create_food.erb"))
        renderer.result(binding)
    end

    def insert_new_item(params)
        item = Item.new({
            name: params['foodname'], 
            price: params['foodprice'], 
            categories: params['foodcategory']
        })
        item.save
    end

    def edit_item_form(params)
        id = params['id']
        item_details = Item.get_item_by_id_for_edit_food(id)
        categories = Category.get_all_categories()
        renderer = ERB.new(File.read("./views/edit_food.erb"))
        renderer.result(binding)
    end

    def save_edited_item(params)
        food_id = params['foodid']
        name = params['foodname']
        price = params['foodprice']
        category_id = params['foodcategory']
        Item.update_item(food_id, name, price, category_id)
    end

    def delete_confirmation(params)
        food_id = params['id']
        items = Item.get_item_by_id_for_food_details(food_id)
        renderer = ERB.new(File.read("./views/delete_food.erb"))
        renderer.result(binding)
    end

    def delete_choosen_item(params)
        food_id = params['id']
        Item.drop_item(food_id)
    end
end