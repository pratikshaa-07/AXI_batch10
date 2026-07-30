class seq_item extends uvm_sequence_item;
  rand  bit [7:0]   sop;
  randc bit [3:0]   txn_id;
  rand  bit [31:0]  addr;
  rand  bit [3:0]   len;
  rand  bit [2:0]   size;
  rand  bit [1:0]   burst;
  rand  bit [1:0]   lock;
  rand  bit [1:0]   cache;
  rand  bit [2:0]   prot;
  rand  bit [3:0]   strobe;      // fixed 4 bits: one bit per data byte, max 4 bytes
  rand  bit [7:0]   data[];      // dynamic: 1 byte (read) or up to 4 bytes (write)
  rand  bit [7:0]   eop;
  rand  bit         mode;        // mode=1 write, mode=0 read
  rand  bit         rd_en;
  rand  bit         wr_en;

  bit   [127:0]     rd_data;     // raw beat captured by monitor (not packed)
  bit   [127:0]     wr_data;     // raw beat captured by monitor (not packed)

  function new(string name="");
    super.new(name);
  endfunction

  `uvm_object_utils_begin(seq_item)
    `uvm_field_int(sop,    UVM_ALL_ON)
    `uvm_field_int(txn_id, UVM_ALL_ON)
    `uvm_field_int(addr,   UVM_ALL_ON)
    `uvm_field_int(len,    UVM_ALL_ON)
    `uvm_field_int(size,   UVM_ALL_ON)
    `uvm_field_int(burst,  UVM_ALL_ON)
    `uvm_field_int(lock,   UVM_ALL_ON)
    `uvm_field_int(cache,  UVM_ALL_ON)
    `uvm_field_int(prot,   UVM_ALL_ON)
    `uvm_field_int(strobe, UVM_ALL_ON)
    `uvm_field_array_int(data,   UVM_ALL_ON)
    `uvm_field_int(eop,    UVM_ALL_ON)
  `uvm_object_utils_end

  // ---------------- constraints ----------------
  constraint burst_size {
    burst inside {0,1,2};
  }
  constraint sop_val {
    sop == 8'b10101010;
  }
  constraint eop_val {
    eop == 8'b01010011;
  }
  constraint size_val {
    size inside {[0:4]};
  }
  constraint len_val {
    len inside {[0:15]};
  }

  // data size formula only applies to write packets; capped at 4 bytes (32 bits max)
  constraint data_size {
    if (mode == 1)
      data.size() == ((len+1)*(1<<size));
    else
      data.size() == 1;
  }
  // constraint data_max {
  //   if (mode == 1)
  //     (len+1)*(1<<size) <= 4;   // hard cap: max 32 bits of data
  // }

  // read packet: single data byte must be 0
  constraint rd_pkt_data {
    if (mode == 0)
    {
      data[0] == 8'h00;
      strobe =='b0;
    }
  }
  // write packet: no data byte may collide with sop/eop
  constraint wrt_pkt_data {
    if (mode == 1)
      foreach (data[i]) {
        data[i] != sop;
        data[i] != eop;
      }
  }
endclass
