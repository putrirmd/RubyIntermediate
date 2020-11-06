require 'sinatra'
require './models/item.rb'
require './models/category.rb'

class CetegoriesController
    def show_all_categories
        categories = Category.get_all_categories()
        renderer = ERB.new(File.read("./views/category_list.erb"))
        renderer.result(binding)
    end

    def show_category_details(params)
        id = params['id']
        items = Category.get_all_items_related_by_category_id(id)
        category_details = Category.get_category_detail_by_category_id(id)
        renderer = ERB.new(File.read("./views/category_detail.erb"))
        renderer.result(binding)
    end

    def create_category_form
        renderer = ERB.new(File.read("./views/create_category.erb"))
        renderer.result(binding)
    end

    def insert_new_category(params)
        category = Category.new({
            name: params['categoryname']
        })
        category.save
    end

    def edit_categories_form(params)
        id = params['id']
        category_details = Category.get_category_detail_by_category_id(id)
        renderer = ERB.new(File.read("./views/edit_category.erb"))
        renderer.result(binding)
    end

    def save_edited_category(params)
        category_id = params['categoryid']
        category_name = params['categoryname']
        Category.update_category(category_id, category_name)
    end

    def delete_confirmation(params)
        category_id = params['id']
        category_details = Category.get_category_detail_by_category_id(category_id)
        renderer = ERB.new(File.read("./views/delete_category.erb"))
        renderer.result(binding)
    end

    def delete_choosen_categories(params)
        category_id = params['id']
        Category.drop_category(category_id)
    end
end