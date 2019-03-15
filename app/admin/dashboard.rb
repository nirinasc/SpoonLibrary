ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    # div class: "blank_slate_container", id: "dashboard_default_message" do
    #   span class: "blank_slate" do
    #     span I18n.t("active_admin.dashboard_welcome.welcome")
    #     small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #   end
    # end

    # Here is an example of a simple dashboard with columns and panels.
    #
    columns do
      column do
        panel "Recent Member Requests" do
          # ul do
          #   User.last(5).map do |user|
          #     li link_to(user.firstname, admin_user_path(user))
          #   end
          # end
          table_for User.inactive.last(5) do |t|
            t.column :firstname
            t.column :lastname
            t.column :username
            t.column :email
            t.column :created_at
            t.column '' do |user|
              link_to 'View', admin_user_path(user)
            end
          end
        end
      end

      column do
        panel "Recent Comments" do
          table_for Comment.includes(:user,:book).last(5) do |t|
            t.column :user
            t.column 'Message', :content
            t.column :book
            t.column :created_at
            t.column '' do |comment|
              link_to 'View', admin_book_comment_path(comment.book,comment)
            end
          end
        end
      end
    end

    columns do
      column do
        panel "Recent Loans" do
          table_for Log.book_loan.unreturned.includes(:user,:book).last(5) do |t|
            t.column :user
            t.column :book
            t.column :date
            t.column :due_date
            column 'Recorded at', :created_at
            t.column '' do |book_loan|
              link_to 'View', admin_log_path(book_loan)
            end
          end
        end
      end

      column do
        panel "Recent returns" do
          table_for Log.book_return.includes(:user,:book, loan: [:book]).last(5) do |t|
            t.column :user
            t.column :book
            t.column 'Referenced Loan', :loan
            t.column :date
            t.column '' do |book_return|
              link_to 'View', admin_log_path(book_return)
            end           
          end
        end
      end
    end
  end
end
