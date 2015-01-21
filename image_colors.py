import os
import sys
import math
from PIL import Image, ImageFilter
#from output import *

def load_image(im):
  try:
    my_im = Image.open(im)
    #my_im.load()
    return my_im
  except:
    return "error"

def color_difference(c1,c2,th):
  rd = abs( int(c1[0])-int(c2[0]) )
  gd = abs( int(c1[1])-int(c2[1]) )
  bd = abs( int(c1[2])-int(c2[2]) )
  t = rd+gd+bd
  return t>=th

def get_distinct_colors(co,th,mn,mx):
  colors = []
  for c in co:
    same = False
    if not color_difference(c,(0,0,0),mn):
      continue
    if not color_difference(c,(255,255,255),mx):
      continue
    for k in colors:
      if not color_difference(c,k,th):
        same = True
        break
    if not same:
      colors.append(c)
  return colors

def get_extremes(v,c):
  start = 255-v
  r = start
  count = 0
  i = 0
  for cs in c:
    ca = (cs[0]+cs[1]+cs[2])/3
    if start > 0:
      if ca < r:
        r = ca
        i=count
    else:
      if ca > r:
        r = ca
        i=count
    count+=1
  return i

def main(kwargs):
  #terminal output init
  #out = output(kwargs[1])
  #if not out.valid:
  #  print "Did not recognize format \""+ kwargs[1]+"\""
  #  return
  #parameters
  threshold = len(kwargs)>2 and kwargs[2] or 50
  min_brightness = len(kwargs)>3 and kwargs[3] or 50
  max_brightness = len(kwargs)>4 and kwargs[4] or 200
  display = len(kwargs)>5 and kwargs[5] or True
  debug = len(kwargs)>6 and kwargs[6] or False
  if min_brightness > 255 or max_brightness > 255:
    print "minimum and maximum brightness must be between 0 and 255"
    return
  if threshold > 255:
    print "threshold should be an integer between 0 and 255"
    return
  #Load the image and create an array of colors
  fuzziness = 5
  print "threshold:"+str(threshold)+" min_brightness:"+str(min_brightness)+" max_brightness:"+str(max_brightness)+" display:"+str(display)+" debug:"+str(debug)
  my_im = load_image(kwargs[1])
  if my_im != "error":
    w,h = my_im.size
    if debug:
      print "image width:"+str(w)
      print "image height:"+str(h)
  else:
    print "image not recognized"
    return
  colors = []
  l = my_im.load()
  for x in range(0,w-1,fuzziness):
    for y in range(0,h-1,fuzziness):
      c = l[x,y]
      colors.append(c)
  #get distinct colors
  distinct_colors = get_distinct_colors(colors,threshold,min_brightness,max_brightness)
  #ensure there are 16
  count = 0
  nc = 17 #number of colors + 1
  while len(distinct_colors)<nc:
    count+=1
    distinct_colors.extend(get_distinct_colors(colors,threshold-count,min_brightness,max_brightness))
    if count == threshold:
      print "could not get colors from image with settings specified, Aborting.\n"
      return
  if len(distinct_colors)>nc:
    del distinct_colors[nc:]

  #get the darkest and lightest color
  darkest_i = get_extremes(0,distinct_colors)
  darkest = distinct_colors[darkest_i]
  del distinct_colors[darkest_i]
  '''lightest_i = get_extremes(255,distinct_colors)
  lightest = distinct_colors[lightest_i]
  del distinct_colors[lightest_i]'''
  #display
  if display:
    margin = 16
    im = Image.new("RGB", (512+(margin*2), 512+(margin*2)), darkest)
    #im = Image.new("RGB", (512+(margin*2), 512+(margin*2)), 0x000000)
    sq = 128
    count = 0
    for c in distinct_colors:
      x = ((count%4)*sq)+margin
      y = ((count/4)*sq)+margin
      im.paste(c,(x,y,x+sq,y+sq))
      count+=1
    #im.paste(lightest,(margin*2,margin*2,margin*4,margin*4))
    im.show()

  #output
  #print out.output(distinct_colors,lightest,darkest)
  dc = distinct_colors
  pblock(dc[0],dc[1],dc[2],dc[3])
  pblock(dc[4],dc[5],dc[6],dc[7])
  pblock(dc[8],dc[9],dc[10],dc[11])
  pblock(dc[12],dc[13],dc[14],dc[15])
  '''print "<parameter name=\"Palette\" value=\""+str(dc[0][0])+" "+str(dc[1][0])+" "+str(dc[2][0])+" "+str(dc[3][0])+" "+str(dc[0][1])+" "+str(dc[1][1])+" "+str(dc[2][1])+" "+str(dc[3][1])+" "+str(dc[0][2])+" "+str(dc[1][2])+" "+str(dc[2][2])+" "+str(dc[3][2])+" 1.0 1.0 1.0 1.0\" />"
  print "<parameter name=\"Luma\" value=\""+str(lum(dc[0]))+" "+str(lum(dc[1]))+" "+str(lum(dc[2]))+" "+str(lum(dc[3]))+"\" />"
  print "<parameter name=\"Palette\" value=\""+str(dc[4][0])+" "+str(dc[5][0])+" "+str(dc[6][0])+" "+str(dc[7][0])+" "+str(dc[4][1])+" "+str(dc[5][1])+" "+str(dc[6][1])+" "+str(dc[7][1])+" "+str(dc[4][2])+" "+str(dc[5][2])+" "+str(dc[6][2])+" "+str(dc[7][2])+" 1.0 1.0 1.0 1.0\" />"
  print "<parameter name=\"Luma\" value=\""+str(lum(dc[4]))+" "+str(lum(dc[5]))+" "+str(lum(dc[6]))+" "+str(lum(dc[7]))+"\" />"
  print "<parameter name=\"Palette\" value=\""+str(dc[8][0])+" "+str(dc[9][0])+" "+str(dc[10][0])+" "+str(dc[11][0])+" "+str(dc[8][1])+" "+str(dc[9][1])+" "+str(dc[10][1])+" "+str(dc[11][1])+" "+str(dc[8][2])+" "+str(dc[9][2])+" "+str(dc[10][2])+" "+str(dc[11][2])+" 1.0 1.0 1.0 1.0\" />"
  print "<parameter name=\"Luma\" value=\""+str(lum(dc[8]))+" "+str(lum(dc[9]))+" "+str(lum(dc[10]))+" "+str(lum(dc[11]))+"\" />"
  print "<parameter name=\"Palette\" value=\""+str(dc[12][0])+" "+str(dc[13][0])+" "+str(dc[14][0])+" "+str(dc[15][0])+" "+str(dc[12][1])+" "+str(dc[13][1])+" "+str(dc[14][1])+" "+str(dc[15][1])+" "+str(dc[12][2])+" "+str(dc[13][2])+" "+str(dc[14][2])+" "+str(dc[15][2])+" 1.0 1.0 1.0 1.0\" />"
  print "<parameter name=\"Luma\" value=\""+str(lum(dc[12]))+" "+str(lum(dc[13]))+" "+str(lum(dc[14]))+" "+str(lum(dc[15]))+"\" />"
  '''
  '''s=""
  for c in distinct_colors:
    luma = math.ceil( (math.sqrt(math.pow(c[0]*0.299,2)+math.pow(c[1]*0.587,2)+math.pow(c[2]*0.114,2))/255.0)*1000 )/1000.0
    nc = (math.ceil((c[0]/255.0)*1000)/1000.0, math.ceil((c[1]/255.0)*1000)/1000.0, math.ceil((c[2]/255.0)*1000)/1000.0)
    s+=str(nc)+":"+str(luma)+"\n"

  print s'''

def pblock(ca,cb,cc,cd):
  nca = c(ca)
  ncb = c(cb)
  ncc = c(cc)
  ncd = c(cd)
  print "<parameter name=\"Palette\" value=\""+str(nca[0])+" "+str(ncb[0])+" "+str(ncc[0])+" "+str(ncd[0])+" "+str(nca[1])+" "+str(ncb[1])+" "+str(ncc[1])+" "+str(ncd[1])+" "+str(nca[2])+" "+str(ncb[2])+" "+str(ncc[2])+" "+str(ncd[2])+" 1.0 1.0 1.0 1.0\" />"
  print "<parameter name=\"Luma\" value=\""+str(lum(ca))+" "+str(lum(cb))+" "+str(lum(cc))+" "+str(lum(cd))+"\" />"

def c(c):
  return (math.ceil((c[0]/255.0)*1000)/1000.0, math.ceil((c[1]/255.0)*1000)/1000.0, math.ceil((c[2]/255.0)*1000)/1000.0)

def lum(c):
  return math.ceil( (math.sqrt(math.pow(c[0]*0.299,2)+math.pow(c[1]*0.587,2)+math.pow(c[2]*0.114,2))/255.0)*1000 )/1000.0

if __name__ == "__main__":
  main(sys.argv)
