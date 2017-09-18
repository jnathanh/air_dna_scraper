class Washington

  def counties
    data[:counties].keys
  end

  def county(county_name)
    data[:counties][county_name.to_s.underscore.to_sym]
  end

  def cities_in(county_name:)
    county(county_name)[:cities]
  end

  def data
    washington = {
      counties:{
        king:{
          cities:[
            'Algona',
            'Auburn',
            'Aukeen',
            'Bellevue',
            'Black Diamond',
            'Bothell',
            'Burien',
            'Carnation',
            'Clyde Hill',
            'Des Moines',
            'Duvall',
            'Enumclaw',
            'Federal Way',
            'Hunts Point',
            'Issaquah',
            'Kent',
            'Kirkland',
            'Lake Forest Park',
            'Maple Valley',
            'Medina',
            'Mercer Island',
            'Normandy Park',
            'North Bend',
            'Pacific',
            'Redmond',
            'Renton',
            'SeaTac',
            'Seattle',
            'Shoreline',
            'Skykomish',
            'Snoqualmie',
            'Tukwila',
            'Vashon Island',
            'Woodinville',
            'Yarrow Point',
          ]
        },
        snohomish:{
          cities:[
            'Arlington',
            'Brier',
            'Cascade',
            'Darrington',
            'Edmonds',
            'Everett',
            'Gold Bar',
            'Granite Falls',
            'Index',
            'Lake Stevens',
            'Lynnwood',
            'Marysville',
            'Mill Creek',
            'Monroe',
            'Mountlake Terrace',
            'Mukilteo',
            'Snohomish',
            'Stanwood',
            'Sultan',
            'Tulalip',
            'Woodway',
          ]
        },
        pierce:{
          cities:[
            'Bonney Lake',
            'Buckley',
            'Carbonado',
            'DuPont',
            'Eatonville',
            'Edgewood',
            'Fife',
            'Fircrest',
            'Gig Harbor',
            'Lakewood',
            'Milton',
            'Orting',
            'Puyallup',
            'Roy',
            'Ruston',
            'South Prairie',
            'Steilacoom',
            'Sumner',
            'Tacoma',
            'Wilkeson',
          ]
        }
      }
    }
  end
end
