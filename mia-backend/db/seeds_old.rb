# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


ROOT_USER = User.create!({
    :first_name => 'Brendan',
    :last_name => 'Asselstine',
    :email => 'mail.asselstine@gmail.com',
    :password => 'rocketsauce',
    :password_confirmation => 'rocketsauce'
})
ROOT_USER.confirm!

motifs = {

  'Type' => {

      'Media' => [
          'Film',
          'Television',
          'Ad',
          'Music Video',
          'Short Film',
          'Case Study',
          'Promo',
          'Government',
          'Non-profit',
          'Random theme/idea/emotion'
      ],
      'Image' => [
        'Live Action',
        'Animation',
        'Hybrid'
      ],
      'Genres' => {
          'Film' => {
              'Comedy' => [],
              'Documentary' => [
                  'Verité',
                  'Mockumentary',
                  'Nature',
                  'Biographic'
              ],
              'Action' => [],
              'Fantasy' => [],
              'Horror' => []
          },
          'Music Video' => {
            'Pop' => [],
            'Rock' => [],
            'Country' => []
          },
          'Ad' => [
              'Demo',
              'Show the problem',
              'Symbolize the problem',
              'Symbolize the benefit',
              'Comparison',
              'Exemplary story',
              'Benefit causes story',
              'Testimonial',
              'On-going character or celebrity',
              'Associated user imagery',
              'Unique personal property',
              'parody or borrowed format'
          ],
          'Undefined' => {
            'Bunch of people doing the same thing' => [],
            'Drinking shot' => [],
            'Product shot' => [],
            'Interior' => [
                'Bathroom',
                'Kitchen'
            ],
            'Exterior' => [],
            'Limbo' => [],
            'Food fight' => [],
            'Dream Sequence' => [],
            'Vox Pop' => []
          }
      }
  },
  'Editing' => {
      'Style' => {
          'Classical' => [
              'Invisible Edit',
              'Temporal & spatial continuity'
          ],
          'Post-classical' => [
              'Discontinuity',
              'Effects',
              'Fragments'
          ]
      },
      'Transitions' => [
        'Wipe',
        'Dissolve',
        'Morph',
        'Push',
        'Rhythm'
      ],
      'Cuts' => [
          'Cheat',
          'Contrast',
          'Smash',
          'Jump',
          'Parallel',
          'Referent'
      ],
      'Duration' => [
          'Fast cut (hip-hop)',
          'Long take',
          'Freeze frame'
      ],
      'Matches' => [
          'Graphic Match',
          'Match on action',
          'eyeline match',
          'form cut',
          'morph (dissolve)'
      ],
      'Superimposition' => [
          'Text',
          'Graphic',
          'Image',
          'Colormatte finale',
          'Product finale'
      ],
      'Techniques' => [
          'Overlapping',
          'Fade in/out',
          'Reverse motion',
          'Soviet Montage',
          'Split-screen',
          'Elliptical',
          'Discontinuous',
          'Walk and talk',
          'Reaction shot',
          'Flashback / flashforward'
      ]
  },
  'Mise-en-Scene' => {
      'Set Design' => [
          'Props',
          'Modern',
          'Historical',
          'Futuristic',
          'Dominant Colour',
          'Working Class',
          'Upper Class',
          'Middle Class',
          'Geometrical',
          'Dominant Object',
          'Minimalist'
      ],
      'Lighting' => {
          'High-key Lighting' => [
              'No Dark',
              'No Tension',
              'Bright',
              'Soft',
              'Barely Shadows',
              'Comedies'
          ],
          'Low-key Lighting' => [
              'Strong Contrast',
              'Mysteries',
              'Thrillers'
          ],
          'High Contrast (tragedy melodrama)' => [],
          'Moderate-key Lighting' => [],
          'Available Light' => []
      },
      'Make-up & Hair' => [
          'Colour',
          'Creatures'
      ],
      'Costume / Wardrobe' => [
          'Retro',
          'Futuristic',
          'Casual',
          'Elegant'
      ],
      'Location / Setting' => [
          'On-location',
          'Fabricated Set',
          'Animated',
          'Limbo'
      ],
      'Space' => [
          'Deep Space',
          'Shallow Space (flat)',
          'Frontality (direct address)',
          'Off-screen space'
      ],
      'Acting' => [
          'Naturalistic',
          'Stylized',
          'Blocking'
      ],
      'Film Stock' => [
          'Black & White',
          'Colour',
          'Grainy',
          'Hybrid'
      ]
  },
  'Cinematographic' => {
    'Composition' => {
        'Static' => [
            'Centers',
            'Symmetrical'
        ],
        'Dynamic (diagonal)' => [],
        'Minimal' => [],
        'Lines' => [],
        'Shapes' => [],
        'Rule of Thirds' => []
    },
    'Focus' => [
        'Deep',
        'Shallow',
        'Racking'
    ],
    'Lens' => [
        'Wide',
        'Telephoto',
        'Standard'
    ],
    'Framing' => [
        'Canted',
        'Centered',
        'De-centered',
        'High Level',
        'Low Level'
    ],
    'Distance' => [
        'Extreme long shot',
        'Extreme close up'
    ],
    'Angle' => [
        'High',
        'Low',
        'Birds-eye',
        'Worms-eye'
    ],
    'Movement' => {
        'Tracking' => [],
        'Pan' => [
            'Following',
            'Surveying',
            'Whip'
        ],
        'Dolly' => [],
        'Crane' => [],
        'Handheld' => [],
        'Steady' => [],
        'Tilt' => [],
        'Zoom' => [],
        'Spin' => []
    },
    'Aspect Ratio' => [
        '4:3',
        '16:9',
        'Cinemascope'
    ],
    'Colour Grading' => [
        'Bleach Bypass',
        'Duotone',
        'Tritone',
        'Orange & Teal',
        'Flat look'
    ],
    'Techniques' => [
        'Timelapse',
        'Silhouette',
        'Double Exposure',
        'Forced Perspective',
        'Optical Illusions'
    ]
  },
  'Visual Effects' => {
      'Digital' => [
          'Rain',
          'Lightning',
          'Tornado',
          'Fire',
          'Energy',
          'Lasers',
          'Fluids',
          'Cloths',
          'Dust',
          'Particles',
          'Explosion',
          'Collapses',
          'Implosion',
          'Disappearances',
          'Invisibility'
      ],
      'Matte Painting' => [],
      'Animation' => [
          '2d Character',
          '2d Infographics',
          '2d Graphics/Objects',
          '2d animals',
          '2d typography',
          '3d character',
          '3d graphics/objects',
          '3d character',
          '3d animals',
          '3d infographics',
          '3d typography',
          '2d/3d hybrid',
          'Claymation',
          'Stop Motion',
          'Cut-out',
          'Motion Graphics',
          'Traditional',
          'Product Animation',
          'Environments'
      ],
      'Special Effects' => [
          'Matte Shot',
          'Rear projection/ front projection',
          'Bullets',
          'Animatronics',
          'Stunts',
          'Pyrotechnics',
          'Breakaway doors or walls',
          'Miniatures',
          'Makeup',
          'Wind',
          'Rain',
          'Snow',
          'Fire',
          'Smoke'
      ],
      'Techniques' => [
          'Slow / fast motion',
          'Motion Control',
          'Motion Tracking',
          'Crowd Replication',
          'Morphing',
          'Keying',
          'Day to Night',
          'Motion Capture',
          'Lens Flare'
      ]
  },
  'Sound' => {
      'Source' => [
          'Diegetic',
          'Non-diegetic',
          'Internal Diegetic'
      ],
      'Editing' => [
          'Sound Bridge',
          'Non-synchronous',
          'Synchronous',
          'Sonic Flashback',
          'Off-screen',
          'Sound Perspective',
          'Silence',
          'Voice-over',
          'Selective'
      ],
      'Recording' => [
          'Direct',
          'Studio'
      ],
      'Music' => [
          'Classical',
          'Rock',
          'Pop',
          'Cinematic',
          'Children'
      ],
      'Sound Effects' => [
          'Swooshes',
          'Futuristic',
          'Nature',
          'Cartoon',
          'Transitions',
          'Urban'
      ]
  }
}

class << self

  def parse_motif(motif, parent = nil)
    parent_id = parent.nil? ? nil : parent.id
    m = Motif.where(:name => motif, :parent_id => parent_id).first_or_create({
            :name => motif,
            :parent => parent,
            :owner => ROOT_USER
    })
  end

  def parse_motif_array(motifs, parent = nil)
    motifs.each do |motif_name|
      motif = parse_motif(motif_name, parent)
    end
  end

  def parse_motif_hash(motifs, parent = nil)
    motifs.keys.each { |motif_name|
      motif = parse_motif(motif_name, parent)
      value = motifs[motif_name]
      if value.is_a?(Hash)
        parse_motif_hash(value, motif)
      elsif value.respond_to?(:each)
        parse_motif_array(value, motif)
      else
        parse_motif(value, motif)
      end
    }
  end




end

parse_motif_hash(motifs)



media = Motif.find_by_name("Media")


film = media.children.find_by_name("Film")
unless film.icon_url.present?
  film.icon = File.open(Rails.root.join('db','seeds','icons','camera.png'))
  film.save!
end

tv = media.children.find_by_name('Television')
unless tv.icon_url.present?
  tv.icon = File.open(Rails.root.join('db','seeds','icons','tv.png'))
  tv.save!
end

music = media.children.find_by_name('Music Video')
unless music.icon_url.present?
  music.icon = File.open(Rails.root.join('db','seeds','icons','music.png'))
  music.save!
end