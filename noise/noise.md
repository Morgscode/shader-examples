## what is noise?

- smooth psudo-random values
- used extensiovely in procedural content generation
- can be used to contrsuct anything from 2D patterns to entire 3D worlds

## value noise

- grid of random values
- sample from the grid of random values
- blend between values on the grid to generate the psedo-random noise

## gradient noise

- grid of random unit length vectors
- sample from the grid of random unit length vectors
- calculate the dot product for each of the N surrounding samples and blend
