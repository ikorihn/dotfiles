# You can override some default right prompt options in your config.fish:
#     set -g theme_date_format "+%a %H:%M"
#     set -g theme_date_timezone America/Los_Angeles

function fish_right_prompt -d 'bobthefish is all about the right prompt'
#     set -l __bobthefish_left_arrow_glyph \uE0B3
#     if [ "$theme_powerline_fonts" = "no" -a "$theme_nerd_fonts" != "yes" ]
#         set __bobthefish_left_arrow_glyph '<'
#     end
# 
#     set_color $fish_color_autosuggestion
# 
#     __bobthefish_cmd_duration
#     __bobthefish_timestamp
#     set_color normal
end
