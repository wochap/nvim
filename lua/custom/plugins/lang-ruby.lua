local constants = require "custom.utils.constants"

return {
  {
    enabled = not constants.first_install,
    import = "lazyvim.plugins.extras.lang.ruby",
  },
}
