ActiveAdmin.register Comment do
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
    belongs_to :book

    filter :user
    filter :content
    filter :created_at

    index :title => proc{ @book.name + ' #Comments'} do
        id_column
        column :user
        column :content
        column :created_at
        actions
    end

    #show page
    show do
        attributes_table do
            row :user
            row :book
            row :content
            row :created_at
        end
    end

    #form
    permit_params :book_id, :content

    form do |f|
        inputs do
            input :content
        end
        actions
    end

    before_create do |comment|
        comment.user = current_user
    end

    controller do
        before_action  -> { @book = Book.find(params[:book_id]) }

        def new
            @page_title = "#{@book.name} #New Comment" 
            super
        end
        def edit
           @page_title = "Edit Comment ##{resource.id}"
           super
        end 
    end

end
