require 'rrobots'

# A psychotic robot that moves to the bottom of the screen, turns horizontal
# to the battlefield, oscillates back and forth across the screen spraying fire.
class Spaceinvader
  include Robot
  attr_reader :at_bottom, :turned, :at_right, :at_left
  def initialize
    @at_bottom = false
    @turned = false
    @at_right = false
    @at_left = true
  end

  def tick(events)
    fire 0.1
    to_the_bottom
    battle_position
    back_and_forth if turned
  end

  def to_the_bottom
    return false if at_bottom
    turn_down
    goto_bottom
  end

  def battle_position
    return false unless at_bottom
    turn_horizontal
    aim_straight_up
  end

  def back_and_forth
    at_left && !at_right ? move_right : move_left
  end

  private

  def turn_down
    difference = (270 - heading).abs
    return if difference < 1
    if heading > 90 && heading < 270
      turn_left
    else
      turn_right
    end
  end

  # Rotate left to south
  def turn_left
    difference = 270 - heading
    difference < 10 ? turn(difference) : turn(10)
  end

  # rotate right to south
  def turn_right
    difference = heading - 270
    (difference < 10 && difference > 0) ? turn(difference) : turn(-10)
  end

  def goto_bottom
    if y < battlefield_height - 61
      accelerate 1
    else
      @at_bottom = true
      stop
    end
  end

  def aim_straight_up
    turn_gun(5) unless gun_heading == 90
  end

  def turn_horizontal
    if heading != 0
      turn(1)
    else
      @turned = true
    end
  end

  # Move all the way to the right
  def move_right
    if x < battlefield_width - 100
      accelerate 1
    else
      @at_right = true
      @at_left = false
    end
  end

  # move all the way to the left
  def move_left
    if x > battlefield_width - 1500
      accelerate(-1)
    else
      @at_left = true
      @at_right = false
    end
  end
end
