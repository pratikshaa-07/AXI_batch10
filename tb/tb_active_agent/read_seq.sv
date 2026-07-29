//--------------------------------------------------------------------------------------------
// Class: cpu_read_seq
// NEW FILE. Sibling of cpu_write_seq - the project only had a write sequence,
// there was no way to drive a CPU-side read at all. Same style/structure as
// cpu_write_seq: one cpu_tx item per body(), only the packet type + wr_en/rd_en
// polarity differ (READ_PKT, rd_en=1, wr_en=0). strobe/data are left to the
// cpu_tx read_pkt_c constraint (forces data[0]==0, strobe all 0 for a read).
//--------------------------------------------------------------------------------------------
class cpu_read_seq extends uvm_sequence #(seq_item);

  `uvm_object_utils(cpu_read_seq)

  seq_item req;

  function new(string name = "");
    super.new(name);
  endfunction

  task body();

    req = seq_item::type_id::create("req");

    start_item(req);

    assert(req.randomize() with {
      mode     == 0;
      wr_en    == 0;
      rd_en    == 1;
      strobe   == 4'b1111;
    });

    finish_item(req);

  endtask

endclass
