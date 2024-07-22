# Mesh-Generator
## Components: 
<details>
  <summary> Is the Point in the Polygon? </summary>
  In order to create the mesh within the polygon, we will create points along the polygon that we will connect to create triangles within it. In doing so there will be some triangle that will lie outside the polygon, thus we must identify such points that will do that (so we can remove them later). This function will be called `inpolygon(p,pv)`
  </details>
<details>
  <summary> Triangle properties </summary>
  Now we need information from these triangles, such as their area, centroid, and circumcenter. These will be recorded under the functions `tri_area(tri)`, `tri_centroid(tri)`, and `tri_circumcenter(tri)`.
</details>
<details>
  <summary> Generating the Mesh </summary>
  Now we get the the main code of the project (called `pmesh(pv,hmax)`, where `pv` is the information of the polygon (that is it's points) and `hmax` are it's side lengths). Here we will follow the steps: 
  
(a) The input `pv` is an array of points which defines the polygon. Note that the last point is equal to the first (a closed polygon).

(b) First, create node points `p` along each polygon segment, separated by a distance approximately equal to `hmax`. Make sure not to duplicate any nodes.

(c) Triangulate the domain using the `delaunay` function.

(d) Remove the triangles outside the polygon, by computing all the triangle centroids (using `tri_centroid`) and determining if they are inside (using `inpolygon`).

(e) Find the triangle with largest area $A$ (using `tri_area`). If $A>h_\mathrm{max}^2/2$, add the circumcenter of the triangle to the list of node points `p`.

(f) Repeat steps (c)-(d), that is, re-triangulate and remove outside triangles.

(g) Repeat steps (e)-(f) until no triangle area $A>h_\mathrm{max}^2/2$.
</details>

## Results

![alt text][logo]

[logo]:<https://github.com/user-attachments/assets/a4744bae-af13-47ea-a8f4-c5aa0bdd8cf3>
