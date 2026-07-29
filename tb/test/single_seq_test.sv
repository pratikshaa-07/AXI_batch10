//--------------------------------------------------------------------------------------------
// Class: single_seq_test
// Minimal test for running exactly ONE cpu_write_seq item - bypasses top_vseq
// entirely, starts directly on the cpu sequencer.
//--------------------------------------------------------------------------------------------
class single_seq_test extends base_test;

  `uvm_component_utils(single_seq_test)

  function new(string name = "", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    cpu_write_seq seq;
    phase.raise_objection(this);

    seq = cpu_write_seq::type_id::create("seq");
    
    //change it
    seq.start(tenv.env.act_agt.seqr);

    phase.drop_objection(this);
  endtask

endclass
