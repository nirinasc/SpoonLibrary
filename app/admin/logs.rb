ActiveAdmin.register Log do
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
    scope 'Books Loan', :book_loan, default: true
    scope 'Books Return', :book_return

    filter :user 
    filter :book
    filter :date
    filter :returned

    index do
        id_column
        column :user 
        column :book
        column 'Referenced Book Loan' do |book_return|
            link_to book_return.loan, admin_log_path(book_return.loan)
        end if params[:scope] == 'books_return'
        column :date
        column :due_date if params[:scope] == 'books_loan'
        column :returned if params[:scope] == 'books_loan'
        column 'Recorded at', :created_at
        actions
    end

    #show page
    show do
        attributes_table do
            row :user
            row :book
            row :date
            row "Referenced Book Loan" do |book_return|
                link_to book_return.loan, admin_log_path(book_return.loan)
            end if resource.book_return?
            row :returned if resource.book_loan?
            row "Recored at", :created_at
        end
    end

    #form
    permit_params :user_id, :book_id, :loan_id, :classification, :date, :due_date, :returned

    form do |f|
        inputs do
            f.input :user, input_html: { disabled: f.object.persisted? ? true : false }
            f.input :book, input_html: { disabled: f.object.persisted? ? true : false }
            f.input :loan, as: select, collection: Log.book_loan.collect{|book_loan| [book_loan, book_loan.id]}, allow_blank: true, input_html: { disabled: f.object.persisted? ? true : false }
            f.input :classification, label: 'Type' unless f.object.persisted?
            f.input :date
            f.input :due_date unless f.object.persisted? && f.object.book_return?
            f.input :returned unless f.object.persisted? && f.object.book_return?
        end
        actions
    end

end
