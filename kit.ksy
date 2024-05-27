meta:
  id: kit
  file-extension: kit
seq:
    - id: samples
      type: sample
      repeat: eos
types:
  sample:
    seq: 
      - id: len
        type: u4le
      - id: riff
        size: len
