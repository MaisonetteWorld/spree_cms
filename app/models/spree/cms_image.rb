module Spree
  class CmsImage < Spree::Asset
    include ActiveModel::AttributeMethods

    validate :no_attachment_errors

    has_attached_file :attachment,
                      styles: {
                        retina: '2400x>',
                        large: '1800x>',
                        medium: '900x>',
                        small: '500x>',
                        mini: '200x>',
                        icon: '50x>'
                      },
                      default_style: :normal,
                      path: 'media/cmsimage/:id/:style/:basename.:extension',
                      default_url: 'media/cmsimage/:id/:style/:basename.:extension',
                      convert_options: { all: '-strip -colorspace sRGB' },
                      processors: %i[thumbnail paperclip_optimizer]
    validates_attachment :attachment, presence: true, content_type: {
      content_type: %w[image/jpeg image/jpg image/png image/gif]
    }
    after_post_process :find_dimensions

    def url(size)
      attachment.url(size, false)
    end

    def find_dimensions
      temporary = attachment.queued_for_write[:original]
      filename = temporary.path unless temporary.nil?
      filename = attachment.path if filename.blank?
      geometry = Paperclip::Geometry.from_file(filename)
      self.attachment_width = geometry.width
      self.attachment_height = geometry.height
    end

    def no_attachment_errors
      unless attachment.errors.empty?
        errors.add :attachment, "Paperclip returned errors for file '#{attachment_file_name}' - check ImageMagick installation or image source file."
        false
      end
    end
  end
end
