-- Pull in the weztrm API
local wezterm = require 'wezterm'

-- this table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- this is where you actually apply your config choices
-- For example, changing the color scheme:
config.color_scheme = 'iceberg-dark'

-- and finally. return the configuration to wezterm

return config
