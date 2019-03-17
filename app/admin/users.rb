ActiveAdmin.register User do
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

  scope 'Members', :member, default: true
  scope 'Admins', :admin

  filter :username
  filter :email
  filter :firstname
  filter :lastname
  filter :created_at
  filter :active

  index do
    selectable_column
    id_column
    column :firstname
    column :lastname
    column :username
    column :email
    column :active
    column :created_at
    actions
  end

  # show page
  show do
    attributes_table do
      row :email
      row :username
      row :firstname
      row :lastname
      row :role
      row :active
      row 'Country' do |user|
        ISO3166::Country[user.country_code]
      end
      row :city
      row :address
      row :zip_code
      row :phone
    end
  end

  # form
  permit_params do
    permitted = %i[firstname lastname email username role active country_code city address zip_code phone]
    permitted += %i[password password_confirmation] if params[:action] == 'create' && current_user.admin?
    permitted
  end

  form do |f|
    inputs do
      input :firstname
      input :lastname
      input :email
      input :username
      input :password, as: 'password' if f.object.new_record?
      input :password_confirmation, as: 'password' if f.object.new_record?
      input :role
      input :active
      input :country_code, label: 'Country', as: 'country', include_blank: true
      input :city
      input :address
      input :zip_code
      input :phone
    end
    actions
  end

  # callbacks
  after_create do |user|
    AdminMailer.account_created(user, permitted_params[:user][:password]).deliver_later if user.active?
  end

  before_update do |user|
    old_user = User.find(user.id)
    user.approved = user.member? && user.active? && !old_user.active?
  end

  after_update do |user|
    AdminMailer.account_approved(user).deliver_later if user.approved
  end
end
