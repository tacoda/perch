nikon_monarch = Lens.create!(
  name: "Nikon Monarch 5 8x42",
  category: "Binoculars",
  image: "binoculars.png",
  description: "Lightweight and durable binoculars with excellent clarity and waterproof design, perfect for birding in all conditions."
)

vortex_diamondback = Lens.create!(
  name: "Vortex Diamondback HD 10x42",
  category: "Binoculars",
  image: "binoculars.png",
  description: "Crisp optics and rugged construction make this a great all-around choice for wildlife observation and hiking."
)

zeiss_terra = Lens.create!(
  name: "Zeiss Terra ED 8x32",
  category: "Binoculars",
  image: "binoculars.png",
  description: "Compact binoculars that deliver bright images and a wide field of view in a lightweight package."
)

celestron_ultima = Lens.create!(
  name: "Celestron Ultima 80",
  category: "Scope",
  image: "spyglass.png",
  description: "Versatile spotting scope with an 80mm objective lens and 20–60x zoom, great for long-range birding."
)

vanguard_endeavor = Lens.create!(
  name: "Vanguard Endeavor HD 65A",
  category: "Scope",
  image: "spyglass.png",
  description: "Angled eyepiece design and ED glass offer sharp, clear images with reduced chromatic aberration."
)

kowa_tsn = Lens.create!(
  name: "Kowa TSN-883",
  category: "Scope",
  image: "spyglass.png",
  description: "Premium fluorite crystal scope with exceptional resolution and brightness for serious birders."
)

canon_eos_r10 = Lens.create!(
  name: "Canon EOS R10",
  category: "Camera",
  image: "camera.png",
  description: "Lightweight mirrorless camera with fast autofocus and 4K video — great for capturing birds in flight."
)

sony_rx10 = Lens.create!(
  name: "Sony RX10 IV",
  category: "Camera",
  image: "camera.png",
  description: "Powerful bridge camera with a 600mm equivalent zoom and fast tracking ideal for bird photography."
)

nikon_d500 = Lens.create!(
  name: "Nikon D500",
  category: "Camera",
  image: "camera.png",
  description: "Pro-level DSLR with excellent low-light performance and 10 fps burst mode — a favorite for birders."
)

ian = User.create!(
  username: "Ian",
  password: "secret"
)

FieldKitItem.create!([
  {
    user: ian,
    lens: nikon_monarch
  },
  {
    user: ian,
    lens: celestron_ultima
  },
  {
    user: ian,
    lens: canon_eos_r10
  }
])

Sighting.create!([
  {
    user: ian,
    lens: nikon_monarch,
    species: "American Robin",
    weight: 0.08,
    length: 0.25,
    likes_count: 3
  },
  {
    user: ian,
    lens: celestron_ultima,
    species: "Great Blue Heron",
    weight: 2.5,
    length: 1.2,
    likes_count: 7
  },
  {
    user: ian,
    lens: canon_eos_r10,
    species: "Bald Eagle",
    weight: 4.5,
    length: 0.9,
    likes_count: 12
  }
])
