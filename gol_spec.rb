require 'rspec'


#  context 'cellular automata rules' do
#    # Testing Rule 1
#    it 'should have any live cell with fewer than two live neighbors die, as if caused by under-population.' do
#      cell = Cell.new(world)
#      cell.spawn_at(2,0)
#      world.tick!
#      cell.should be_dead
#    end
#
#    # Testing Rule 2
#    it 'should have any live cell with two or three live neighbors live on to the next generation.' do
#      cell = Cell.new(world)
#      new_cell = cell.spawn_at(1,0)
#      other_cell = cell.spawn_at(-1, 0)
#      world.tick!
#      cell.should be_alive
#    end
#
#    # Testing Rule 3
#    it 'should have any live cell with more than three live neighbors die, as if by overcrowding.' do
#      cell = Cell.new(world)
#      north_neighbor = cell.spawn_at(0,1)
#      east_neighbor = cell.spawn_at(1,0)
#      north_east_neighbor = cell.spawn_at(1,1)
#      south_neighbor = cell.spawn_at(0, -1)
#      world.tick!
#      cell.should be_dead
#    end
#
#    # Testing Rule 4
#    it 'should have any dead cell with exactly three live neighbors become a live cell, as if by reproduction' do
#      cell = Cell.new(world)
#      world.tick!
#      # Kill the cell, confirm it died
#      cell.should be_dead
#      north_neighbor = cell.spawn_at(0,1)
#      east_neighbor = cell.spawn_at(1,0)
#      south_neighbor = cell.spawn_at(0,-1)
#      world.tick!
#      # Cell should be alive via reproduction
#      cell.should be_alive
#    end
#  end
#end

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

end

class World
  attr_accessor :cells

  def initialize(x, y)
    @cells = []
    for i in (0...x)
      for j in (0...y)
        @cells << Cell.new(i, j, false)
      end
    end
  end

  #def tick!
  #  #Rule 1
  #  live_cells.each do | cell |
  #    if cell.neighbors.select(&:living?).count < 2
  #      cell.living = false
  #    end
  #  end

  #end

  def live_cells
    @cells.select(&:living?)
  end
end

describe Cell do
  subject { Cell.new(1, 2, true) }
  its(:x) { should eq 1 }
  its(:y) { should eq 2 }
  its(:living?) { should be_true }

  describe "#is_neighbor?" do
    let(:neighbor) { Cell.new(1, 1, true) }
    let(:dead_neighbor) { Cell.new(2, 1, false) }
    let(:non_neighbor) { Cell.new(1, 5, true) }

    it "tells you if it's a neighbor or not" do
      expect(subject.is_neighbor?(neighbor)).to be_true
      expect(subject.is_neighbor?(dead_neighbor)).to be_true
      expect(subject.is_neighbor?(non_neighbor)).to be_false
    end
  end

end

describe World do
  subject { World.new(50, 50) }


  it "creates a world of dead cells" do
    expect(subject.cells.count).to eq(2500)
  end

  it "can find a cell by coordinates" do
    lookup_cell = subject.cells.find{ |cell| cell.x == 1 && cell.y == 1}
    expect(lookup_cell).to be_a(Cell)
  end

  it "will return a collection of live cells" do
    living_cell = subject.cells.find{ |cell| cell.x == 1 && cell.y == 1}
    living_cell.living = true
    expect(subject.live_cells.count).to eq(1)
  end

  xit { should respond_to(:tick!) }

  # Rule 1
  xit "should have any live cell with fewer than two live neighbors die, as if caused by under-population" do
    subject.tick!
    expect(subject.live_cells.count).to eq(0)
  end

end