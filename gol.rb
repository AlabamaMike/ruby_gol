require 'rspec'

class Cell
  attr_accessor :x, :y, :living

  def initialize( x, y, living_status )
    @x = x
    @y = y
    @living = living_status
  end

  def is_neighbor?(cell)
    xoffset = self.x - cell.x
    yoffset = self.y - cell.y
    (xoffset.abs <= 1) && (yoffset.abs <= 1)
  end

  def living?
    @living
  end

  def neighbors(world)
    @neighbors = []
    (-1..1).each do |i|
      (-1..1).each do |j|
        @neighbors << world.cells.find{ |cell| cell.x == i && cell.y == j }
      end
    end
    @neighbors
  end

end

class World
  attr_accessor :cells

  def initialize(x, y)
    @cells = []
     (0...x).each do | i |
        (0...y).each do | j |
        @cells << Cell.new(i, j, false)
      end
    end
  end

  def tick!
    #Rule 1
    live_cells.each do | cell |
      if cell.neighbors(self).select(&:living?).count < 2
        cell.living = false
      end
    end

  end

  def live_cells
    @cells.select(&:living?)
  end
end

describe Cell do

  let(:world) { World.new(10, 10) }

  subject { world.cells.find{ |cell| cell.x == 1 && cell.y == 2} }
  its(:x) { should eq 1 }
  its(:y) { should eq 2 }
  its(:living?) { should be_false }

  it 'should have 8 neighbors in the world' do
    expect( subject.neighbors(world).count eq 8 )
  end

  #describe "#is_neighbor?" do
  #  let(:neighbor) { Cell.new(1, 1, true) }
  #  let(:dead_neighbor) { Cell.new(2, 1, false) }
  #  let(:non_neighbor) { Cell.new(1, 5, true) }
  #
  #  it "tells you if it's a neighbor or not" do
  #    expect(subject.is_neighbor?(neighbor)).to be_true
  #    expect(subject.is_neighbor?(dead_neighbor)).to be_true
  #    expect(subject.is_neighbor?(non_neighbor)).to be_false
  #  end
  #end

end

describe World do
  subject { World.new(50, 50) }


  it 'creates a world of 2500 dead cells at initialization' do
    expect(subject.cells.count).to eq(2500)
  end

  it 'can find a cell by coordinates' do
    lookup_cell = subject.cells.find{ |cell| cell.x == 1 && cell.y == 1}
    expect(lookup_cell).to be_a(Cell)
  end

  it 'will return a collection of live cells' do
    living_cell = subject.cells.find{ |cell| cell.x == 1 && cell.y == 1}
    living_cell.living = true
    expect(subject.live_cells.count).to eq(1)
  end

  # Rule 1
  xit 'should have any live cell with fewer than two live neighbors die, as if caused by under-population' do
    living_cell = subject.cells.find{ |cell| cell.x == 1 && cell.y == 1}
    living_cell.living = true
    subject.tick!
    expect(subject.live_cells.count).to eq(0)
  end

end