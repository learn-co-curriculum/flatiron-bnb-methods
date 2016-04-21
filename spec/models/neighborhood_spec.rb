describe Neighborhood do
  let(:nyc) { City.create(name: 'NYC') }
  let(:sf) { City.create(name: 'San Francisco') }
  let(:brighton) { Neighborhood.create(name: 'Brighton Beach', city: nyc) }
  let(:guest) { User.create(name: 'Guest') }
  let(:haight) { Neighborhood.create(name: 'Lower Haight', city: sf) }
  let(:host) { User.create(name: 'Host') }
  let(:listings) do
    [Listing.create(
      address: 'address',
      description: 'description',
      price: 1.00,
      host: User.create(name: 'Host'),
      title: 'title',
      neighborhood: brighton,
      listing_type: 'listing_type'
    ), Listing.create(
      address: 'address',
      description: 'description',
      price: 1.00,
      host: User.create(name: 'Host'),
      title: 'title',
      neighborhood: haight,
      listing_type: 'listing_type'
    )]
  end
  let!(:reservations) do
    Reservation.create(
      check_in: '2014-04-25',
      check_out: '2014-04-30',
      listing: listings[0],
      guest: guest,
      status: 'accepted'
    )

    Reservation.create(
      check_in: '2014-03-10',
      check_out: '2014-03-25',
      listing: listings[1],
      guest: guest,
      status: 'accepted'
    )

    Reservation.create(
      check_in: '2014-06-02',
      check_out: '2014-06-30',
      listing: listings[1],
      guest: guest,
      status: 'accepted'
    )
  end

  it '#name' do
    expect(brighton.name).to eq('Brighton Beach')
  end

  it '#city' do
    expect(brighton.city).to eq(nyc)
  end

  it 'has many listings' do
    expect(brighton.listings).to include(listings[0])
  end

  it '#neighborhood_openings' do
    expect(brighton.neighborhood_openings('2014-05-01', '2014-05-05')).to include(listings[0])
  end

  it '.highest_ratio_reservations_to_listings' do
    expect(Neighborhood.highest_ratio_reservations_to_listings).to eq(haight)
  end

  it '.most_reservations' do
    expect(Neighborhood.most_reservations).to eq(haight)
  end
end
