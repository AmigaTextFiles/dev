if not exists jx4:jax4th.make
s:jaxforth
endif
copy jax4th.a ram:jax4th.a
copy jax4th.i ram:asminc/jax4th.i
pushdir ram:
asmc:casm -W jx4:jax4th.with
popdir
jax4th.lnk
