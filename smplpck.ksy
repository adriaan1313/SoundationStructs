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
      #- id: unk3
      #  contents: [00, 00, 00, 00, 40, 6F, 12, 83, 3A, CD, CC, CC, 3D, 00, 00, 80, 3F, 66, 66, E6, 3E ]
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
      - id: unk1
        size: 9
      - id: mult
        type: u1
        if: _root.header.file_version >= 2
      - id: unk2_v2_3
        size: 3
        if: _root.header.file_version >= 2
      - id: rate
        type: u4le
      - id: unk3
        size: 1
      - id: smpl_count
        type: u4le
      - id: samples
        type: 
          switch-on: _root.header.file_version
          cases:
            1: sam_arr_v1
            _: sam_arr_v2
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
        #contents: "ZONE"
        size: 4
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
  sam_arr_v1:
      seq:
      - id: samples
        size: _parent.smpl_count * 2
  sam_arr_v2:
      seq:
      - id: samples
        size: _parent.smpl_count * 2 * _parent.mult
