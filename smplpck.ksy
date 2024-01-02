meta:
  id: smplpck
  file-extension: smplpck
  endian: le
seq:
 - id: header
   type: header
 - id: sample_list
   type: slst
 - id: zone_list
   type: zlst
types:
  header:
    seq:
      - id: magic
        contents: "SMPLPCK"
      - id: file_version
        type: u1
      - id: unk
        size: 1
      - id: title_length
        type: u2
      - id: title
        type: str
        encoding: utf8
        size: title_length
      - id: unk2 
        size: 0x5
      - id: att
        type: f4 #*1000 ms
      - id: dec
        type: f4 #*1000 ms
      - id: sus
        type: f4 #
      - id: rel
        type: f4 #*1000 ms
  slst:
    seq:
      - id: header
        contents: "SLST"
      - id: number_of_samples
        type: u2
      - id: smpls
        type: smpl
        repeat: expr
        #repeat-expr: 18
        repeat-expr: number_of_samples

  smpl:
    seq: 
      - id: header
        contents: "SMPL"
      - id: name_length
        if: _root.header.file_version >= 3
        type: u2
      - id: name
        if: _root.header.file_version >= 3
        size: name_length
        type: str
        encoding: ascii
      - id: base_note
        type: u1
        if: _root.header.file_version < 2
        
      - id: unk_n1
        size: 1
        if: _root.header.file_version >= 2
      - id: unk
        size: 9
      - id: unk1
        size: 3
        if: _root.header.file_version >= 2
      - id: rate
        type: u4le
      - id: unk2
        size: 1
      - id: smpl_count
        type: u4le
      - id: samples
        size: smpl_count*2
  zlst:
    seq:
      - id: header
        contents: "ZLST"
      - id: zone_count
        type: u2
      - id: zones
        type: zone
        repeat: expr
        repeat-expr: zone_count
  zone:
    seq:
      - id: header
        contents: "ZONE"
      - id: related_sample
        type: u2
      #- id: unk
      #  size: 1
      - id: bottom_note
        type: u1
      - id: top_note
        type: u1
      - id: bottom_velocity #presumably
        type: u1
      - id: top_velocity #presumably
        type: u1
      - id: base_note
        type: u1
        if: _root.header.file_version >= 2
      - id: unk3
        size: 6
        if: _root.header.file_version >= 2
      - id: pan
        size: 1
        if: _root.header.file_version >= 2
      - id: unk4
        size: 1
        if: _root.header.file_version >= 2