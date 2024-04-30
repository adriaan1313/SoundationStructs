meta:
  id: spcpack
  file-extension: spcpack
seq:
    - id: num_samples
      type: u1
    - id: samples
      type: sample
      repeat: expr
      repeat-expr: num_samples
types:
  sample:
    seq:
      - id: title_len
        type: u1
      - id: title
        type: str
        encoding: utf8
        size: title_len
      - id: cut #the sample number it is able to cut off (default value)
        type: u1
      - id: num
        type: u1
      - id: unk2
        size: 4
      - id: riff_magic #quite a janky way to do this, but i didn't want to import the whole riff wav struct
        size: 4
      - id: riff_len
        type: u4le
      - id: riff_data
        size: riff_len
  
