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
 if (!req.randomize() with { mode == 1; wr_en == 1; rd_en == 0; strobe == 4'b1111;len==0;size==2; })
  `uvm_fatal("CPU_WR_SEQ", "Randomization failed")

    finish_item(req);

  endtask

endclass
