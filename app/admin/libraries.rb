ActiveAdmin.register Library do
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
  filter :country_code, label: 'Country', as: :select,
                        collection: ISO3166::Country.countries.sort_by(&:name).collect { |country| [country.name, country.alpha2] },
                        include_blank: true

  index do
    id_column
    column :name
    column 'Country' do |library|
      ISO3166::Country[library.country_code]
    end
    column :city
    column :address
    column :phone
    column :created_at
    actions
  end

  # show page
  show do
    attributes_table do
      row :name
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
  permit_params :name, :country_code, :city, :address, :zip_code, :phone

  form do |_f|
    inputs do
      input :name
      input :country_code, label: 'Country', as: 'country'
      input :city
      input :address
      input :zip_code
      input :phone
    end
    actions
  end
end
