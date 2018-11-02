require 'plane'
require 'airport'

describe Plane do
  it 'can land at an airport if not already landed' do
    plane = Plane.new
    airport = instance_double('Airport', :stormy? => false, :accept => nil, :full? => false)
    plane.land(airport)
    expect { plane.land(airport) }.to raise_error('This plane has already landed')
  end

  it 'can take off if currently at an airport' do
    plane = Plane.new
    expect { plane.take_off }.to raise_error('The plane is not on the ground')
    airport = instance_double('Airport', :stormy? => false, :accept => nil, :release => nil, :full? => false)
    plane.land(airport)
    expect { plane.take_off }.not_to raise_error
    expect { plane.take_off }.to raise_error('The plane is not on the ground')
  end

  describe 'stormy weather' do
    it 'will not take off if the weather is stormy' do
      storm_port = instance_double('Airport', :stormy? => false, :accept => nil, :full? => false)
      subject.land(storm_port)
      allow(storm_port).to receive(:stormy?) {true}
      expect { subject.take_off }.to raise_error('Stormy weather prevents the plane from taking off')
    end

    it 'will not land if the weather is stormy' do
      storm_port = instance_double('Airport', :stormy? => true, :accept => nil, :full? => false)
      expect { subject.land(storm_port) }.to raise_error('Stormy weather prevents the plane from landing')
    end
  end

  it 'will not land if the airport is full' do
    airport = instance_double('Airport', :stormy? => false, :accept => nil, :full? => true)
    expect { subject.land(airport) }.to raise_error('Cannot land at this airport as it is full')
  end
end
