module TinymceHelper
  include MacrosHelper

  def tinymce_js
    output = ''
    output += javascript_include_tag 'tinymce/js/tinymce/tinymce.js'
    output += javascript_include_tag 'tinymce/js/tinymce/jquery.tinymce.min.js'
    output += javascript_include_tag 'tinymce.js'
    output += include_macro_js_files.to_s
    output
  end

  def tinymce_init_js options = {}
    options.merge! :document_base_url => top_url,
      :content_css => "/stylesheets/tinymce.css,#{macro_css_files}",
      :plugins => %w[compat3x advlist autolink lists link image charmap print preview hr anchor pagebreak
        searchreplace wordcount visualblocks visualchars code fullscreen
        insertdatetime media nonbreaking save table contextmenu directionality
        emoticons template paste textcolor colorpicker textpattern],
      :image_advtab => true,
      :language => tinymce_language

    options[:toolbar1] = "fullscreen | insertfile undo redo | copy paste | bold italic underline | styleselect fontsizeselect | forecolor backcolor | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image"
    if options[:mode] == 'simple'
      options[:menubar] = false
    else
      options[:menubar] = 'edit insert view tools'
      options[:toolbar2] = 'print preview code media | table'

      options[:toolbar2] += ' | macros'
      macros_with_buttons.each do |macro|
        options[:toolbar2] += " #{macro.identifier}"
      end
    end

    options[:macros_setup] = macros_with_buttons.map do |macro|
      <<-EOS
        ed.addButton('#{macro.identifier}', {
          title: #{macro_title(macro).to_json},
          onclick: #{generate_macro_config_dialog macro},
          image : '#{macro.configuration[:icon_path]}'
        });
      EOS
    end

    #cleanup non tinymce options
    options = options.except :mode

    "noosfero.tinymce.init(#{options.to_json})"
  end

end
