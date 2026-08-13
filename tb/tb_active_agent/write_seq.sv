class cpu_write_seq extends uvm_sequence #(seq_item);

  `uvm_object_utils(cpu_write_seq)

  seq_item req;

  function new(string name="");
    super.new(name);
  endfunction

  task body();

    req = seq_item::type_id::create("req");

    start_item(req);

    // assert(req.randomize() with {
    //   mode ==  1;
    //   //strobe == 4'b1111;
    // });
 if (!req.randomize() with { mode == 1; wr_en == 1; rd_en == 0; strobe == 4'b1111;len==1;size==1;addr=='b110; })
  `uvm_fatal("CPU_WR_SEQ", "Randomization failed")
  $display("address=%0h",req.addr);
  $display("data=%0p",req.data);
  if (!req.randomize() with { mode == 0; wr_en == 1; rd_en == 0; strobe == 4'b1111;len==1;size==1;addr=='b110; })
  `uvm_fatal("CPU_WR_SEQ", "Randomization failed")
  $display("address=%0h",req.addr);
  $display("data=%0p",req.data);
 
    finish_item(req);

  endtask

endclass
