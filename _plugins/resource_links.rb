module Jekyll
  class FileLinksTag < Liquid::Tag
    def initialize(tag_name, text, tokens)
      super
      @text = text.strip
      @paths = {:mac => "/Volumes/", :win => "S:\\", :nix => "/n/facilities/"}
    end

    def render(context)
      win_path, nix_path, mac_path = convert_path(@text)
      text = "<div class=\"file_links\">\n"
      text += "<p><span class=\"file_link_info\">win</span><a href=\"file://#{win_path}\">#{win_path}</a><br/></p>\n"
      text += "<p><span class=\"file_link_info\">nix</span><a href=\"file://#{nix_path}\">#{nix_path}</a><br/></p>\n"
      text += "<p><span class=\"file_link_info\">mac</span><a href=\"file://#{mac_path}\">#{mac_path}</a><br/></p>\n"
      text += "</div>\n"
      text
    end

    def convert_path(original_path)
      common_path = get_common_path(original_path)
      win_path = @paths[:win] + common_path.gsub(/\//,"\\")
      nix_path = @paths[:nix] + common_path
      mac_path = @paths[:mac] + common_path
      return [win_path, nix_path, mac_path]
    end

    def get_common_path(path)
      common_path = path
      if path =~ Regexp.new(@paths[:mac])
        common_path = path.split("/")[2..-1].join("/")
      else
        raise "ERROR invalid path: #{path}"
      end
      common_path
    end
  end
end

Liquid::Template.register_tag('file', Jekyll::FileLinksTag)

