# Mandelbrot fractal

In this code, a function is implemented in Octave to computationally study the behavior of a sequence of complex numbers $z_k$, as a function of a constant $c \in C$, defined by
$z_0 = 0$ and  $z_{k+1} = z_k^2 + c.$
Thus, the set is defined as
$$MB=\{c \in \mathbb{C} : |z_k| \not\to \infty\}.$$

The set $MB$ is called the Mandelbrot set.
The developed function will allow generating a visualization of the set of complex numbers for which the sequence $z_k$ does not diverge to $\infty$. To do this, it calculates the number of iterations required to satisfy the condition $|z_k|>2$ and, depending on the result, checks if $c$ belongs to the set $MB$, in case the maximum number of iterations has occurred.
The result will be a matrix that stores the number of iterations performed, which can be used to generate images representing the set $MB$, the famous Mandelbrot fractal.

Fractals are sets for which the fractal dimension, or Hausdorff-Besicovitch dimension, strictly exceeds the topological dimension. They are important in various fields of science and engineering due to their ability to model complex natural phenomena, such as the shape of mountains, the structure of blood vessels, and the distribution of galaxies in the universe.

The fractal dimension is a measure that describes how completely a fractal fills space as it is observed at smaller and smaller scales. Unlike the Euclidean dimension (which is an integer), the fractal dimension can be a fractional number, reflecting the complexity of the object. Formally, the Hausdorff-Besicovitch dimension \(D\) for a set \(F\) is defined as:
$D = \inf \{ d \geq 0 : \lim_{\epsilon \to 0} \inf ( \sum_{i}( \text{diam}(U_i))^d) = 0 \}$
where $\{U_i\}$ is a cover of $F$ by sets of diameter at most $\epsilon$.

The fractal dimension of the boundary of the Mandelbrot set is 2, while its topological dimension is 1, so the boundary of $MB$ is a fractal.

To implement this code we use version 9.2.0 of Octave and we also use the optional functionality of parallelization across the various CPU cores, For that it necessary to install the *struct* and *parallel* packages. These can be installed from the Octave terminal using the commands:

>>pkg install -forge struct

>>pkg install -forge parallel

+
