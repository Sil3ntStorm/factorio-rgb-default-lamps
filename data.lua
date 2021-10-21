data:extend{
  {
    type="simple-entity-with-owner",
    name="rgb-lamp-light",
    flags={"placeable-off-grid"},
    render_layer="light-effect",
    picture={
      filename = "__base__/graphics/entity/small-lamp/lamp-light.png",
      priority = "high",
      width = 46,
      height = 40,
      frame_count = 1,
      axially_symmetrical = false,
      direction_count = 1,
      shift = util.by_pixel(0, -6),
      draw_as_glow=true,
      apply_runtime_tint = true,
      hr_version =
      {
        filename = "__base__/graphics/entity/small-lamp/hr-lamp-light.png",
        priority = "high",
        width = 90,
        height = 78,
        frame_count = 1,
        axially_symmetrical = false,
        direction_count = 1,
        shift = util.by_pixel(0, -8),
        scale = 0.55,
        draw_as_glow=true,
        apply_runtime_tint = true
      }
    }
  }
}
