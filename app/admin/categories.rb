ActiveAdmin.register Category do
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

  filter :name

  index do
    id_column
    column :name
    column :created_at
    actions
  end

  # show page
  show do
    attributes_table do
      row :name
      row :description
      row :created_at
    end
  end

  # form
  permit_params :name, :description

  form do |_f|
    inputs do
      input :name
      input :description
    end
    actions
  end
end
