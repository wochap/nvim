local M = {}

-- Function to convert hex color to RGB
M.hex_to_rgb = function(hex)
  -- Remove "#" if present
  hex = hex:gsub("^#", "")

  -- Check if valid hex string
  if not hex:match "^%x%x%x%x%x%x$" then
    return nil
  end

  -- Convert hex to RGB values
  local r = tonumber(hex:sub(1, 2), 16)
  local g = tonumber(hex:sub(3, 4), 16)
  local b = tonumber(hex:sub(5, 6), 16)

  -- Return RGB string
  return string.format("rgb(%d, %d, %d)", r, g, b)
end

-- Function to convert RGB color to hex
M.rgb_to_hex = function(rgb)
  -- Extract RGB values using pattern matching
  local r, g, b = rgb:match "rgb%((%d+),%s*(%d+),%s*(%d+)%)"

  -- Check if valid RGB string
  if not (r and g and b) then
    return nil
  end

  -- Convert to numbers
  r, g, b = tonumber(r), tonumber(g), tonumber(b)

  -- Validate ranges
  if r < 0 or r > 255 or g < 0 or g > 255 or b < 0 or b > 255 then
    return nil
  end

  -- Convert to hex and return
  return string.format("#%02X%02X%02X", r, g, b)
end

return M
