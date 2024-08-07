function huifushu= huifu(fuheshu,QL)
huifushu=fuheshu;
if QL(5)==1
  huifushu=huifushu-length(39:40);
end
if QL(4)==1
  huifushu=huifushu-length(29:30);
end
if QL(3)==1
  huifushu=huifushu-length(33:35);
end
if QL(2)==1
 huifushu=huifushu-length(23);
end
if QL(1)==1
 huifushu=0;
end
