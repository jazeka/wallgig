ActiveAdmin.register Wallpaper do
  permit_params :purity, :tag_list

  index do
    selectable_column
    column 'Id', sortable: :id do |wallpaper|
      link_to wallpaper.id, admin_wallpaper_path(wallpaper)
    end
    column 'Thumbnail' do |wallpaper|
      link_to admin_wallpaper_path(wallpaper) do
        if wallpaper.thumbnail_image.present?
          image_tag wallpaper.thumbnail_image.url, width: 125, height: 94
        else
          'Processing'
        end
      end
    end
    column :purity, &:purity_text
    column :tag_list, sortable: false
    column 'Views', :impressions_count
    column 'Favourites', sortable: :favourites_count do |wallpaper|
      link_to wallpaper.favourites_count, admin_favourites_path(q: { wallpaper_id_eq: wallpaper })
    end
    column :user
    column :processing, sortable: :processing do |wallpaper|
      status_tag wallpaper.processing? ? 'Yes' : 'No'
    end
    column :created_at
    column :updated_at
    actions
  end

  show do
    panel 'Wallpaper Details' do
      attributes_table_for wallpaper do
        row :user
        row :purity, &:purity_text
        row :tag_list
        row :primary_color do |wallpaper|
          content_tag :div, nil, style: "width: 50px; height: 50px; background-color: #{wallpaper.primary_color.to_html_hex}" if wallpaper.primary_color.present?
        end
        row :color do |wallpaper|
          ul style: 'list-style: none; padding: 0' do
            wallpaper.wallpaper_colors.map do |wallpaper_color|
              li wallpaper_color.percentage.round(2), style: "display: inline-block; width: 50px; height: 50px; background-color: #{wallpaper_color.to_html_hex}"
            end
          end
        end
        row :created_at
        row :updated_at
      end
    end
    panel 'Stats' do
      attributes_table_for wallpaper do
        row :impressions_count
        row :favourites_count
      end
    end
    panel 'Image' do
      attributes_table_for wallpaper do
        row :processing do |wallpaper|
          status_tag wallpaper.processing? ? 'Yes' : 'No'
        end
        row :image do
          image_tag wallpaper.image.url
        end
        row :image_uid
        row :image_name
        row :image_width
        row :image_height
        row :thumbnail_image_uid
        row :image_gravity, &:image_gravity_text
      end
    end
    active_admin_comments
  end

  form do |f|
    f.inputs do
      f.input :purity
      f.input :tag_list
      f.input :image_gravity
    end
    f.actions
  end

  member_action :recreate_thumbnails, method: :get do
    wallpaper = Wallpaper.find(params[:id])
    wallpaper.queue_create_thumbnails
    redirect_to action: :show, notice: 'Thumbnail recreation request queued.'
  end

end