require 'rspec'

#class Cell
#  attr_accessor :world, :x, :y
#
#  def initialize(world, x=0, y=0)
#    @world = world
#    @x = x
#    @y = y
#    world.cells << self
#  end
#
#  def die!
#    world.cells -= [ self ]
#  end
#
#  def live!
#    world.cells += [ self ]
#  end
#
#  def dead?
#    !world.cells.include?(self)
#  end
#
#  def alive?
#    world.cells.include?(self)
#  end
#
#  def neighbors
#    @neighbors = []
#    world.cells.each do |cell|
#      #Detect cells to the north
#      if self.x == cell.x && self.y == cell.y - 1
#        @neighbors << cell
#      end
#
#      #Detect cells to the north west
#      if self.x == cell.x + 1 && self.y == cell.y - 1
#        @neighbors << cell
#      end
#
#      #Detect cells to the north east
#      if self.x == cell.x - 1 && self.y == cell.y - 1
#        @neighbors << cell
#      end
#
#      #Detect cells to the west
#      if self.x == cell.x + 1 && self.y == cell.y
#        @neighbors << cell
#      end
#
#      #Detect cells to the east
#      if self.x == cell.x - 1 && self.y == cell.y
#        @neighbors << cell
#      end
#
#      #Detect cells to the south
#      if self.x == cell.x  && self.y == cell.y + 1
#        @neighbors << cell
#      end
#
#      #Detect cells to the south west
#      if self.x == cell.x + 1  && self.y == cell.y + 1
#        @neighbors << cell
#      end
#
#      #Detect cells to the south east
#      if self.x == cell.x - 1  && self.y == cell.y + 1
#        @neighbors << cell
#      end
#
#    end
#
#    @neighbors
#  end
#
#  def spawn_at(x, y)
#    Cell.new(world, x, y)
#  end
#
#
#end

class World
  attr_accessor :cells
  def initialize
    @cells = []
  end

  def tick!
    cells.each do | cell |
      #Rule 1 & Rule 3
      if cell.neighbors.count < 2 || cell.neighbors.count > 3
        cell.die!
      end

      #Rule 4
      cell.neighbors.each do | neighbor |
        if neighbor.neighbors.count == 3
          cells << neighbor unless cells.include?(neighbor)
        end
      end

    end

  end

end

#describe 'game of life' do
#
#  let(:world) { World.new }
#
#  context 'cell helper methods' do
#    subject { Cell.new(world) }
#
#    it 'spawns at' do
#      cell = subject.spawn_at(3,3)
#      cell.is_a?(Cell).should be_true
#      cell.x.should eq(3)
#      cell.y.should eq(3)
#      cell.world.should == subject.world
#    end
#
#    it 'detects a neighbor to the north' do
#      cell = subject.spawn_at(0,1)
#      subject.neighbors.count.should eq(1)
#    end
#
#    it 'detects a neighbor to the north west' do
#      cell = subject.spawn_at(-1, 1)
#      subject.neighbors.count.should eq (1)
#    end
#
#    it 'detects a neighbor to the north east' do
#      cell = subject.spawn_at(1,1)
#      subject.neighbors.count.should eq (1)
#    end
#
#    it 'detects a neighbor to the west' do
#      cell = subject.spawn_at(-1, 0)
#      subject.neighbors.count.should eq (1)
#    end
#
#    it 'detects a neighbor to the east' do
#      cell = subject.spawn_at(1,0)
#      subject.neighbors.count.should eq (1)
#    end
#
#    it 'detects a neighbor to the south' do
#      cell = subject.spawn_at(0, -1)
#      subject.neighbors.count.should eq (1)
#    end
#
#    it 'detects a neighbor to the south west' do
#      cell = subject.spawn_at(-1, -1)
#      subject.neighbors.count.should eq (1)
#    end
#
#    it 'detects a neighbor to the south east' do
#      cell = subject.spawn_at(1, -1)
#      subject.neighbors.count.should eq (1)
#    end
#
#    it 'detects a neighbor to the south and north ' do
#      south_cell = subject.spawn_at(0, -1)
#      north_cell = subject.spawn_at(0, 1)
#      subject.neighbors.count.should eq (2)
#    end
#
#    it 'dies' do
#      subject.die!
#      subject.world.cells.should_not include(subject)
#    end
#
#    it 'lives' do
#      subject.live!
#      subject.world.cells.should include(subject)
#    end
#
#  end
#
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
  attr_accessor :x, :y, :living_status

  def initialize( x, y, living_status )
    @x = x
    @y = y
    @living_status = living_status
  end

  def is_neighbor?(cell)
    xoffset = self.x - cell.x
    yoffset = self.y - cell.y
    (xoffset.abs <= 1) && (yoffset.abs <= 1)
  end

end

describe Cell do
  subject { Cell.new(1, 2, true) }
  its(:x) { should eq 1 }
  its(:y) { should eq 2 }
  its(:living_status) { should be_true }

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