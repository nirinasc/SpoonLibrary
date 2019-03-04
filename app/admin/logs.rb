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
        actions do |log|
            item "Add a Book Return", book_return_admin_log_path(log) if log.book_loan? && !log.returned  
        end
    end

    #show page
    show do
        attributes_table do
            row :user
            row :book
            row :date
            row :due_date if resource.book_loan?
            row "Referenced Book Loan" do |book_return|
                link_to book_return.loan, admin_log_path(book_return.loan)
            end if resource.book_return?
            row :returned if resource.book_loan?
            row "Referenced return" do |book_loan|
                link_to book_loan.return, admin_log_path(book_loan.return) if book_loan.return    
            end if resource.book_loan? && resource.returned
            row "Recored at", :created_at
        end
    end

    #form
    permit_params :user_id, :book_id, :loan_id, :classification, :date, :due_date, :returned

    form do |f|
        inputs do
            f.input :user, input_html: { disabled: f.object.persisted? ? true : false }
            f.input :book, input_html: { disabled: f.object.persisted? ? true : false }
            if f.object.new_record?
                f.input :loan, as: 'select', collection: Log.book_loan.unreturned.collect{|book_loan| [book_loan, book_loan.id]}, allow_blank: true
            else
                f.input :loan, input_html: { disabled: true } 
            end
            f.input :classification, label: 'Type' unless f.object.persisted?
            f.input :date
            f.input :due_date unless f.object.persisted? && f.object.book_return?
            f.input :returned unless f.object.persisted? && f.object.book_return?
        end
        actions
    end

    member_action :book_return , method: [:get, :post] do
        @page_title = "Add Book Return"

        classification = Log.classifications[:book_return]

        if request.post?
            data =  params.require(:log).permit(:date).merge({ 'classification': classification, 'user': resource.user, 'book': resource.book, 'loan': resource })
            @book_return = Log.new(data)

            if @book_return.valid?
                @book_return.save
                redirect_to admin_log_path @book_return , notice: "The Book Return was successfully created" 
            else
            
            end
        else
            @book_return = Log.new({loan: resource, classification: classification })
        end
    end

end
