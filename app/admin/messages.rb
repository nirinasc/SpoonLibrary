ActiveAdmin.register_page "Messages" do
    menu label: "Mailer", priority: 20

    message = Message.new
    
    content do
        render partial: 'index', locals: { message: message }
    end

    page_action :create, method: :post do

         
        subject = params[:message][:subject]
        content = params[:message][:content]
        recipients = params[:message][:recipients].reject(&:empty?).map(&:squish)

        message = Message.new(subject: subject, content: content, recipients: recipients)
        notice = nil

        if message.valid?
            AdminMailer.notify(recipients: recipients, subject: subject, content: content).deliver_later
            notice = 'The message has been successfully sent'
        end

        redirect_to  admin_messages_path, notice: notice

    end

end