-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
--
config.keys = {
	-- Turn off the default CMD-m Hide action, allowing CMD-m to
	-- be potentially recognized and handled by the tab
	{
		key = "+",
		mods = "CMD",
		action = wezterm.action.IncreaseFontSize,
	},
}

-- For example, changing the color scheme:
config.color_scheme = "Tokyo Night"
config.font_size = 14

config.window_frame = {
	-- The font used in the tab bar.
	-- Roboto Bold is the default; this font is bundled
	-- with wezterm.
	-- Whatever font is selected here, it will have the
	-- main font setting appended to it to pick up any
	-- fallback fonts you may have used there.
	font = wezterm.font({ family = "Iosevka Nerd Font Mono", weight = "Bold" }),

	-- The size of the font in the tab bar.
	-- Default to 10.0 on Windows but 12.0 on other systems
	font_size = 12.0,

	-- The overall background color of the tab bar when
	-- the window is focused
	active_titlebar_bg = "#1a1b26",

	-- The overall background color of the tab bar when
	-- the window is not focused
	inactive_titlebar_bg = "#16161e",
}

config.colors = {
	tab_bar = {
		-- The color of the strip that goes along the top of the window
		-- (does not apply when fancy tab bar is in use)
		background = "#1a1b26",

		-- The active tab is the one that has focus in the window
		active_tab = {
			-- The color of the background area for the tab
			bg_color = "#7aa2f7",
			-- The color of the text for the tab
			fg_color = "#16161e",
		},

		-- Inactive tabs are the tabs that do not have focus
		inactive_tab = {
			bg_color = "#292e42",
			fg_color = "#545c7e",

			-- The same options that were listed under the `active_tab` section above
			-- can also be used for `inactive_tab`.
		},

		-- You can configure some alternate styling when the mouse pointer
		-- moves over inactive tabs
		inactive_tab_hover = {
			bg_color = "#292e42",
			fg_color = "#7aa2f7",

			-- The same options that were listed under the `active_tab` section above
			-- can also be used for `inactive_tab_hover`.
		},

		-- The new tab button that let you create new tabs
		new_tab = {
			bg_color = "#1a1b26",
			fg_color = "#7aa2f7",

			-- The same options that were listed under the `active_tab` section above
			-- can also be used for `new_tab`.
		},

		-- You can configure some alternate styling when the mouse pointer
		-- moves over the new tab button
		new_tab_hover = {
			bg_color = "#1a1b26",
			fg_color = "#7aa2f7",
			intensity = "Bold",

			-- The same options that were listed under the `active_tab` section above
			-- can also be used for `new_tab_hover`.
		},
	},
}

-- and finally, return the configuration to wezterm
return config
