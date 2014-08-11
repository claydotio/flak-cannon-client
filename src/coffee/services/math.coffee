class MathService
  # Determine if two values are statistically different
  # returns the p-value
  #
  # http://www.iancampbell.co.uk/twobytwo/n-1_theory.htm
  # B is successful converions
  # not-B is unsuccessful conversions
  # A is test 1
  # not-A is test 2
  #
  # formula
  # (a*d - b*c)**2 * (N -1) / (m*n*r*s)
  #
  #          B  not-B  Total
  # A     |  a    b      m
  # not-A |  c    d      n
  # Total |  r    s      N
  #
  nMinusOneChiSquare: (aCount, aTotal, bCount, bTotal) ->
    a = aCount
    b = aTotal - aCount
    c = bCount
    d = bTotal - bCount

    r = a + c
    s = b + d
    m = a + b
    n = c + d
    N = m + n + r + s

    chi2 = (a * d - b * c) ** 2 * (N - 1) / (m * n * r * s)
    z = Math.sqrt(Math.abs(chi2))
    1 - @pFromZ(z)

  pFromZ: (z) ->
    Z_MAX = 6.0

    if z == 0.0
      x = 0.0
    else
      y = 0.5 * Math.abs(z)
      if y > (Z_MAX * 0.5)
        x = 1.0
      else if y < 1.0
        w = y * y
        x = ((((((((0.000124818987 * w -
                    0.001075204047) * w + 0.005198775019) * w -
                    0.019198292004) * w + 0.059054035642) * w -
                    0.151968751364) * w + 0.319152932694) * w -
                    0.531923007300) * w + 0.797884560593) * y * 2.0
      else
        y -= 2.0
        x = (((((((((((((-0.000045255659 * y +
                          0.000152529290) * y - 0.000019538132) * y -
                          0.000676904986) * y + 0.001390604284) * y -
                          0.000794620820) * y - 0.002034254874) * y +
                          0.006549791214) * y - 0.010557625006) * y +
                          0.011630447319) * y - 0.009279453341) * y +
                          0.005353579108) * y - 0.002141268741) * y +
                          0.000535310849) * y + 0.999936657524
    if z > 0.0 then ((x + 1.0) * 0.5) else ((1.0 - x) * 0.5)



module.exports = new MathService()
