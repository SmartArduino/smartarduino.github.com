# -*- coding: utf-8 -*-
# A Liquid tag rof Jekyll sites that allows showing exif data.
# by: Gosuke Miyashita
# Modified by: realasking
#
# Example usage: {% exif /images/sample.jpg %}

require 'exifr'
require 'rubygems'
require 'open-uri'

module Jekyll
  class ExifTag < Liquid::Tag
      def initialize(tag_name, file, token)
      super
      @image_file = ""+ file.strip , File.dirname(__FILE__)
    end

    def render(context)
          exif = EXIFR::JPEG::new(@image_file)
          <<-HTML
    焦距 #{exif.focal_length.to_i} mm F#{sprintf "%.1f", exif.f_number.to_f} #{exif.model} ISO #{exif.iso_speed_ratings} #{exif.exposure_time.to_i}s 
    HTML
        end
      end
end

Liquid::Template.register_tag('exif', Jekyll::ExifTag)


