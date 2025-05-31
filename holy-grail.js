const snippet = {
    "Next.js Page Template": {
      "scope": "javascript,typescript,typescriptreact",
      "prefix": "nextpage",
      "body": `

function 1$($2) $3 {
    
}


      `
      .trim().split("\n"), // 🔥 This converts multi-line into an array
      "description": "Creates a Next.js page component"
    }
  };
  
  console.log(JSON.stringify(snippet, null, 2));
