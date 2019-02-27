ActiveAdmin.register Book do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

    filter :library
    filter :name
    filter :isbn
    filter :author
    filter :pub_date
    filter :available

    index do
        selectable_column
        id_column
        column :name
        column 'Cover' do |book|
            image_tag book.cover_image_url(:thumbnail)
        end
        column :isbn
        column :author
        column :pub_date
        column :available
        column :created_at
        actions do |book|
            item "Comments (#{book.comments_count}) ", admin_book_comments_path(book) 
        end
    end

    #show page
    show do
        attributes_table do
            row :name
            row :library
            row :isbn
            row :author
            row :description
            row 'Cover' do |book|
                image_tag book.cover_image_url(:thumbnail)
            end
            row :number_of_pages
            row :format
            row :publisher
            row :pub_date
            row :language
            row :available
            row :created_at
            row 'Comments' do |book|
                link_to book.comments.count, admin_book_comments_path(book)
            end
        end
    end

    #form
    permit_params :library_id, :name, :isbn, :author, :description, :cover_image, :number_of_pages, :format, :publisher, :pub_date, :language, :available

    form :html => { :multipart => true } do |f|
        inputs do
            input :library
            input :name
            input :isbn
            input :author
            input :description
            input :cover_image, as: 'file'
            input :cover_image_cache, as: 'hidden'
            input :number_of_pages
            input :format
            input :publisher
            input :pub_date
            input :language
            input :available
        end
        actions
    end

end
