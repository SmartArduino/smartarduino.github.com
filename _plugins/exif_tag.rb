# -*- coding: utf-8 -*-
# A Liquid tag rof Jekyll sites that allows showing exif data.
# by: Gosuke Miyashita
#
# Example usage: {% exif /images/sample.jpg %}

require 'exifr'

module Jekyll
  class ExifTag < Liquid::Tag
      @img=nil
      def initialize(tag_name, file, token)
      attributes = ['src']
      super
      @img = attributes 
      if @img['src'] !~ /^https?:\/\//
      @image_file = File.expand_path "../" + @img['src'], File.dirname(__FILE__)
      else
      @image_file = @img['src']
    end

    def render(context)
          exif = EXIFR::JPEG::new(@image_file)
          <<-HTML
    焦距 #{exif.focal_length.to_i} mm 光圈F#{sprintf "%.1f", exif.f_number.to_f} #{exif.model} ISO #{exif.iso_speed_ratings} 曝光时间#{exif.exposure_time.to_i}s
    HTML
        end
      end
end

Liquid::Template.register_tag('exif', Jekyll::ExifTag)
